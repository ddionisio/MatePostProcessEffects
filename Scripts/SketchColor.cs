using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

namespace M8.PostProcessEffects {
    [System.Serializable]
    [PostProcess(typeof(SketchColorRenderer), PostProcessEvent.AfterStack, "M8/Sketch Color")]
    public class SketchColor : PostProcessEffectSettings {
        [Tooltip("Displacement of sketch effect, usually set to: 1.25")]
        public FloatParameter threshold = new FloatParameter();
        public ColorConstantParameter paper = new ColorConstantParameter() { value = new Color(0.83f, 0.79f, 0.63f, 1f) };
        
        public override bool IsEnabledAndSupported(PostProcessRenderContext context) {
            return enabled.value && threshold.value != 0f;
        }
    }

    public class SketchColorRenderer : PostProcessEffectRenderer<SketchColor> {

        private Shader mShader;

        private int mPaperID;
        private int mThresholdID;

        public override void Init() {
            mShader = Shader.Find("Hidden/M8/PostProcessEffects/SketchColor");

            mPaperID = Shader.PropertyToID("pap");
            mThresholdID = Shader.PropertyToID("threshold");
        }

        public override void Render(PostProcessRenderContext context) {
            var sheet = context.propertySheets.Get(mShader);

            sheet.properties.SetColor(mPaperID, settings.paper);
            sheet.properties.SetFloat(mThresholdID, settings.threshold);

            context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
        }
    }
}