using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

namespace M8.PostProcessEffects {
    [System.Serializable]
    [PostProcess(typeof(CMYKHalftone2Renderer), PostProcessEvent.AfterStack, "M8/CMYKHalftone2")]
    public class CMYKHalftone2 : PostProcessEffectSettings {
        public FloatConstantParameter dotSize = new FloatConstantParameter() { value = 1.48f };

        public FloatConstantParameter rotation = new FloatConstantParameter();

        public FloatConstantParameter scale = new FloatConstantParameter() { value = 2.5f };

        public Vector4ConstantParameter cmykRotation = new Vector4ConstantParameter() { value = new Vector4(15f, 75f, 0f, 45f) };
    }

    public class CMYKHalftone2Renderer : PostProcessEffectRenderer<CMYKHalftone2> {

        private Shader mShader;

        private int mDotSizeID;
        private int mRotID;
        private int mScaleID;
        private int mCMYKRotID;

        public override void Init() {
            mShader = Shader.Find("Hidden/M8/PostProcessEffects/CMYKHalftone2");

            mDotSizeID = Shader.PropertyToID("dotSize");
            mRotID = Shader.PropertyToID("_r");
            mScaleID = Shader.PropertyToID("_s");
            mCMYKRotID = Shader.PropertyToID("_clrR");
        }

        public override void Render(PostProcessRenderContext context) {
            var sheet = context.propertySheets.Get(mShader);

            sheet.properties.SetFloat(mDotSizeID, settings.dotSize);
            sheet.properties.SetFloat(mRotID, settings.rotation);
            sheet.properties.SetFloat(mScaleID, settings.scale);
            sheet.properties.SetVector(mCMYKRotID, settings.cmykRotation);

            context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
        }
    }
}