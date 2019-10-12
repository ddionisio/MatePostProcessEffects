using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

namespace M8.PostProcessEffects {
    [System.Serializable]
    [PostProcess(typeof(CMYKHalftoneRenderer), PostProcessEvent.AfterStack, "M8/CMYKHalftone")]
    public class CMYKHalftone : PostProcessEffectSettings {
        public FloatParameter uScale = new FloatParameter();

        public FloatConstantParameter frequency = new FloatConstantParameter() { value = 40f };

        public Vector4ConstantParameter rotations = new Vector4ConstantParameter() { value = new Vector4(15f, 75f, 0f, 45f) };
                
        public FloatConstantParameter UYRotation = new FloatConstantParameter() { value = 45f };
    }

    public class CMYKHalftoneRenderer : PostProcessEffectRenderer<CMYKHalftone> {

        private Shader mShader;

        private int mFrequencyID;
        private int mRotationsID;
        private int mUScaleID;
        private int mUYRotationID;

        public override void Init() {
            mShader = Shader.Find("Hidden/M8/PostProcessEffects/CMYKHalftone");

            mFrequencyID = Shader.PropertyToID("frequency");
            mRotationsID = Shader.PropertyToID("rot");
            mUScaleID = Shader.PropertyToID("uScale");
            mUYRotationID = Shader.PropertyToID("uYrot");
        }

        public override void Render(PostProcessRenderContext context) {
            var sheet = context.propertySheets.Get(mShader);

            sheet.properties.SetFloat(mFrequencyID, settings.frequency);
            sheet.properties.SetVector(mRotationsID, settings.rotations);
            sheet.properties.SetFloat(mUScaleID, settings.uScale);
            sheet.properties.SetFloat(mUYRotationID, settings.UYRotation);

            context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
        }
    }
}
 