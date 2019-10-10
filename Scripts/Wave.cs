using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

namespace M8.PostProcessEffects {
    [System.Serializable]
    [PostProcess(typeof(WaveRenderer), PostProcessEvent.BeforeStack, "M8/Wave")]
    public class Wave : PostProcessEffectSettings {

        [Tooltip("Intensity of the wave in X/Y. Typically in fraction.")]
        public Vector2Parameter amplitude = new Vector2Parameter();

        [Tooltip("Speed of the wave in X/Y.")]
        public Vector2Parameter speed = new Vector2Parameter();

        [Tooltip("Scale of the wave. Higher values allow more waves to fit on screen.")]
        public Vector2Parameter range = new Vector2Parameter();
    }

    public class WaveRenderer : PostProcessEffectRenderer<Wave> {

        private const float INV_2PI = 1f / (2f * Mathf.PI);

        private int mParmID;
        private int mSpeedID;

        public override void Init() {
            mParmID = Shader.PropertyToID("parms");
            mSpeedID = Shader.PropertyToID("speed");
        }

        public override void Render(PostProcessRenderContext context) {            
            var sheet = context.propertySheets.Get(Shader.Find("Hidden/M8/PostProcessEffects/Wave"));
                        
            sheet.properties.SetVector(mParmID, 
                new Vector4(
                    settings.amplitude.value.x * INV_2PI, settings.amplitude.value.y * INV_2PI, 
                    settings.range.value.x, settings.range.value.y));

            sheet.properties.SetVector(mSpeedID, settings.speed);

            context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
        }
    }
}