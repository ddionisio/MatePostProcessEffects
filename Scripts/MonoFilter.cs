using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

namespace M8.PostProcessEffects {
    [System.Serializable]
    [PostProcess(typeof(MonoFilterRenderer), PostProcessEvent.AfterStack, "M8/Mono Filter")]
    public class MonoFilter : PostProcessEffectSettings {
        public FloatConstantParameter enhance = new FloatConstantParameter() { value = 1.2f };
    }

    public class MonoFilterRenderer : PostProcessEffectRenderer<MonoFilter> {
        private Shader mShader;

        private int mEnhanceID;

        public override void Init() {
            mShader = Shader.Find("Hidden/M8/PostProcessEffects/MonoFilter");

            mEnhanceID = Shader.PropertyToID("enhance");
        }

        public override void Render(PostProcessRenderContext context) {
            var sheet = context.propertySheets.Get(mShader);

            sheet.properties.SetFloat(mEnhanceID, settings.enhance);

            context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
        }
    }
}