using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

namespace M8.PostProcessEffects {
    [System.Serializable]
    [PostProcess(typeof(WaveRenderer), PostProcessEvent.BeforeStack, "M8/Wave")]
    public class Wave : PostProcessEffectSettings {

        [Tooltip("Intensity of the wave in X/Y. Typically in fraction.")]
        public Vector2Parameter amplitude = new Vector2Parameter();

        [Tooltip("Speed of the wave in X/Y.")]
        public Vector2ConstantParameter speed = new Vector2ConstantParameter();

        [Tooltip("Scale of the wave. Higher values allow more waves to fit on screen.")]
        public Vector2ConstantParameter range = new Vector2ConstantParameter();

        public override bool IsEnabledAndSupported(PostProcessRenderContext context) {
            return enabled.value && amplitude.value != Vector2.zero;
        }
    }

    public class WaveRenderer : PostProcessEffectRenderer<Wave> {

        private const float INV_2PI = 1f / (2f * Mathf.PI);

        private Shader mShader;

        private int mParmID;
        private int mOfsID;

        public override void Init() {
            mShader = Shader.Find("Hidden/M8/PostProcessEffects/Wave");

            mParmID = Shader.PropertyToID("parms");
            mOfsID = Shader.PropertyToID("ofs");
        }

        public override void Render(PostProcessRenderContext context) {            
            var sheet = context.propertySheets.Get(mShader);
                        
            sheet.properties.SetVector(mParmID, 
                new Vector4(
                    settings.amplitude.value.x * INV_2PI, settings.amplitude.value.y * INV_2PI, 
                    settings.range.value.x, settings.range.value.y));

            var ofs = settings.speed.value * Time.time;

            sheet.properties.SetVector(mOfsID, ofs);

            context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
        }
    }
}