using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

namespace M8.PostProcessEffects {
    [System.Serializable]
    [PostProcess(typeof(ChromaticDisplaceRenderer), PostProcessEvent.AfterStack, "M8/Chromatic Displace")]
    public class ChromaticDisplace : PostProcessEffectSettings {
        public FloatParameter displace = new FloatParameter();

        public override bool IsEnabledAndSupported(PostProcessRenderContext context) {
            return enabled.value && displace.value != 0f;
        }
    }

    public class ChromaticDisplaceRenderer : PostProcessEffectRenderer<ChromaticDisplace> {

        private Shader mShader;

        private int mDisplaceID;

        public override void Init() {
            mShader = Shader.Find("Hidden/M8/PostProcessEffects/ChromaticDisplace");

            mDisplaceID = Shader.PropertyToID("displace");
        }

        public override void Render(PostProcessRenderContext context) {
            var sheet = context.propertySheets.Get(mShader);

            sheet.properties.SetFloat(mDisplaceID, settings.displace);

            context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
        }
    }
}