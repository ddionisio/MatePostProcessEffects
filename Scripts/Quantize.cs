using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

namespace M8.PostProcessEffects {
    [System.Serializable]
    [PostProcess(typeof(QuantizeRenderer), PostProcessEvent.AfterStack, "M8/Quantize")]
    public class Quantize : PostProcessEffectSettings {
        [Range(0f, 1f)]
        public FloatParameter blend = new FloatParameter() { value = 1f };

        public IntConstantParameter levels = new IntConstantParameter { value = 16 };

        public override bool IsEnabledAndSupported(PostProcessRenderContext context) {
            return enabled.value && blend.value > 0f;
        }
    }

    public class QuantizeRenderer : PostProcessEffectRenderer<Quantize> {
        
        private Shader mShader;

        private int mBlendID;
        private int mLevelsID;

        public override void Init() {
            mShader = Shader.Find("Hidden/M8/PostProcessEffects/Quantize");

            mBlendID = Shader.PropertyToID("blend");
            mLevelsID = Shader.PropertyToID("levels");
        }

        public override void Render(PostProcessRenderContext context) {
            var sheet = context.propertySheets.Get(mShader);
                        
            sheet.properties.SetInt(mLevelsID, settings.levels);

            var blendVal = settings.blend.value;

            if(blendVal < 1f) {
                sheet.properties.SetFloat(mBlendID, blendVal);

                context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
            }
            else {
                context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 1);
            }
        }
    }
}