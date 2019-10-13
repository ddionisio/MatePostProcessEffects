using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

namespace M8.PostProcessEffects {
    [System.Serializable]
    [PostProcess(typeof(CrossHatchBlendRenderer), PostProcessEvent.AfterStack, "M8/Cross Hatch")]
    public class CrossHatchBlend : PostProcessEffectSettings {
        public ColorParameter lineColor = new ColorParameter() { value = Color.clear };
        public ColorParameter paperColor = new ColorParameter() { value = Color.clear };

        //public FloatConstantParameter fill = new FloatConstantParameter() { value = 0f };

        public FloatConstantParameter lineDistance = new FloatConstantParameter() { value = 10f };
        public FloatConstantParameter lineThickness = new FloatConstantParameter() { value = 1f };

        public Vector4ConstantParameter luminanceThreshold = new Vector4ConstantParameter() { value = new Vector4(0.8f, 0.6f, 0.3f, 0.15f) };

        public Vector4ConstantParameter lineStrength = new Vector4ConstantParameter() { value = new Vector4(0.2f, 0.4f, 0.7f, 1f) };

        public FloatConstantParameter kernelOffset = new FloatConstantParameter() { value = 1f };
    }

    public class CrossHatchBlendRenderer : PostProcessEffectRenderer<CrossHatchBlend> {

        private Shader mShader;

        private int mLineColorID;
        private int mPaperColorID;
        private int mLineDistID;
        private int mLineThicknessID;
        private int mLumThresholdID;
        private int mLineStrengthID;
        private int mKernelOfsID;

        public override void Init() {
            mShader = Shader.Find("Hidden/M8/PostProcessEffects/CrossHatchBlend");

            mLineColorID = Shader.PropertyToID("lineColor");
            mPaperColorID = Shader.PropertyToID("paperColor");
            mLineDistID = Shader.PropertyToID("lineDist");
            mLineThicknessID = Shader.PropertyToID("lineThickness");
            mLumThresholdID = Shader.PropertyToID("lumThreshold");
            mLineStrengthID = Shader.PropertyToID("lineStrength");
            mKernelOfsID = Shader.PropertyToID("d");
        }

        public override void Render(PostProcessRenderContext context) {
            var sheet = context.propertySheets.Get(mShader);

            sheet.properties.SetColor(mLineColorID, settings.lineColor);
            sheet.properties.SetColor(mPaperColorID, settings.paperColor);
            sheet.properties.SetFloat(mLineDistID, settings.lineDistance);
            sheet.properties.SetFloat(mLineThicknessID, settings.lineThickness);
            sheet.properties.SetVector(mLumThresholdID, settings.luminanceThreshold);
            sheet.properties.SetVector(mLineStrengthID, settings.lineStrength);
            sheet.properties.SetFloat(mKernelOfsID, settings.kernelOffset);

            context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
        }
    }
}
 