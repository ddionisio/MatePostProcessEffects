using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

namespace M8.PostProcessEffects {
    [System.Serializable]
    [PostProcess(typeof(DitherRenderer), PostProcessEvent.AfterStack, "M8/Dither")]
    public class Dither : PostProcessEffectSettings {
        public Texture2DConstantParameter pattern = new Texture2DConstantParameter();
        public Texture2DConstantParameter weight = new Texture2DConstantParameter();
        public FloatConstantParameter adjust = new FloatConstantParameter();
    }

    public class DitherRenderer : PostProcessEffectRenderer<Dither> {
        public const string patternProperty = "_DitherTex";
        public const string adjustProperty = "ditherAdjustThreshold";
        public const string stepXProperty = "ditherStepX";
        public const string stepYProperty = "ditherStepY";

        private Shader mShader;

        private int mPatternID;
        private int mAdjustID;
        private int mStepXID;
        private int mStepYID;

        private int mWeightID;

        public override void Init() {
            mShader = Shader.Find("Hidden/M8/PostProcessEffects/Dither");

            //Dither properties
            mPatternID = Shader.PropertyToID(patternProperty);
            mAdjustID = Shader.PropertyToID(adjustProperty);
            mStepXID = Shader.PropertyToID(stepXProperty);
            mStepYID = Shader.PropertyToID(stepYProperty);

            mWeightID = Shader.PropertyToID("_WeightTex");
        }

        public override void Render(PostProcessRenderContext context) {
            var sheet = context.propertySheets.Get(mShader);

            //Dither setup
            sheet.properties.SetFloat(mAdjustID, settings.adjust);

            var patternTex2D = settings.pattern.value;
            if(patternTex2D) {
                sheet.properties.SetTexture(mPatternID, patternTex2D);
                sheet.properties.SetFloat(mStepXID, (float)(context.width / patternTex2D.width));
                sheet.properties.SetFloat(mStepYID, (float)(context.height / patternTex2D.height));
            }

            var weightTex2D = settings.weight.value;
            if(weightTex2D) {
                sheet.properties.SetTexture(mWeightID, weightTex2D);

                context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 1);
            }
            else
                context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
        }
    }
}