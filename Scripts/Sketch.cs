using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

namespace M8.PostProcessEffects {
    [System.Serializable]
    [PostProcess(typeof(SketchRenderer), PostProcessEvent.AfterStack, "M8/Sketch")]
    public class Sketch : PostProcessEffectSettings {
        [Range(0f, 1f)]
        public FloatParameter blend = new FloatParameter();

        public ColorConstantParameter paper = new ColorConstantParameter() { value = new Color(0.82f, 0.77f, 0.61f, 1f) };
        public ColorConstantParameter ink = new ColorConstantParameter() { value = new Color(0.28f, 0.32f, 0.32f, 1f) };

        public override bool IsEnabledAndSupported(PostProcessRenderContext context) {
            return enabled.value && blend.value > 0f;
        }
    }

    public class SketchRenderer : PostProcessEffectRenderer<Sketch> {

        private Shader mShader;

        private int mBlendID;
        private int mPaperID;
        private int mInkID;

        public override void Init() {
            mShader = Shader.Find("Hidden/M8/PostProcessEffects/Sketch");

            mBlendID = Shader.PropertyToID("blend");
            mPaperID = Shader.PropertyToID("pap");
            mInkID = Shader.PropertyToID("ink");
        }

        public override void Render(PostProcessRenderContext context) {
            var sheet = context.propertySheets.Get(mShader);

            sheet.properties.SetColor(mPaperID, settings.paper);
            sheet.properties.SetColor(mInkID, settings.ink);

            var blend = settings.blend.value;
            if(blend < 1f) {
                sheet.properties.SetFloat(mBlendID, blend);

                context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 1);
            }
            else {
                context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
            }
        }
    }
}