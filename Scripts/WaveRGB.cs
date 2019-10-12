using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

namespace M8.PostProcessEffects {
    [System.Serializable]
    [PostProcess(typeof(WaveRendererRGB), PostProcessEvent.BeforeStack, "M8/Wave RGB")]
    public class WaveRGB : PostProcessEffectSettings {
        [Tooltip("Intensity of the wave in X/Y. Typically in fraction.")]
        public Vector2Parameter amplitudeR = new Vector2Parameter();
        [Tooltip("Intensity of the wave in X/Y. Typically in fraction.")]
        public Vector2Parameter amplitudeG = new Vector2Parameter();
        [Tooltip("Intensity of the wave in X/Y. Typically in fraction.")]
        public Vector2Parameter amplitudeB = new Vector2Parameter();

        [Tooltip("Speed of the wave in X/Y.")]
        public Vector2ConstantParameter speedR = new Vector2ConstantParameter();
        [Tooltip("Speed of the wave in X/Y.")]
        public Vector2ConstantParameter speedG = new Vector2ConstantParameter();
        [Tooltip("Speed of the wave in X/Y.")]
        public Vector2ConstantParameter speedB = new Vector2ConstantParameter();

        [Tooltip("Scale of the wave. Higher values allow more waves to fit on screen.")]
        public Vector2ConstantParameter rangeR = new Vector2ConstantParameter();
        [Tooltip("Scale of the wave. Higher values allow more waves to fit on screen.")]
        public Vector2ConstantParameter rangeG = new Vector2ConstantParameter();
        [Tooltip("Scale of the wave. Higher values allow more waves to fit on screen.")]
        public Vector2ConstantParameter rangeB = new Vector2ConstantParameter();

        public override bool IsEnabledAndSupported(PostProcessRenderContext context) {
            return enabled.value && !(amplitudeR.value == Vector2.zero && amplitudeG.value == Vector2.zero && amplitudeB.value == Vector2.zero);
        }
    }

    public class WaveRendererRGB : PostProcessEffectRenderer<WaveRGB> {

        private const float INV_2PI = 1f / (2f * Mathf.PI);

        private Shader mShader;

        private int mParmRID;
        private int mOfsRID;
        private int mParmGID;
        private int mOfsGID;
        private int mParmBID;
        private int mOfsBID;

        public override void Init() {
            mShader = Shader.Find("Hidden/M8/PostProcessEffects/WaveRGB");

            mParmRID = Shader.PropertyToID("parmsR");
            mOfsRID = Shader.PropertyToID("ofsR");
            mParmGID = Shader.PropertyToID("parmsG");
            mOfsGID = Shader.PropertyToID("ofsG");
            mParmBID = Shader.PropertyToID("parmsB");
            mOfsBID = Shader.PropertyToID("ofsB");
        }

        public override void Render(PostProcessRenderContext context) {
            var sheet = context.propertySheets.Get(mShader);

            sheet.properties.SetVector(mParmRID,
                new Vector4(
                    settings.amplitudeR.value.x * INV_2PI, settings.amplitudeR.value.y * INV_2PI,
                    settings.rangeR.value.x, settings.rangeR.value.y));

            sheet.properties.SetVector(mParmGID,
                new Vector4(
                    settings.amplitudeG.value.x * INV_2PI, settings.amplitudeG.value.y * INV_2PI,
                    settings.rangeG.value.x, settings.rangeG.value.y));

            sheet.properties.SetVector(mParmBID,
                new Vector4(
                    settings.amplitudeB.value.x * INV_2PI, settings.amplitudeB.value.y * INV_2PI,
                    settings.rangeB.value.x, settings.rangeB.value.y));

            var t = Time.time;

            sheet.properties.SetVector(mOfsRID, settings.speedR.value * t);
            sheet.properties.SetVector(mOfsGID, settings.speedG.value * t);
            sheet.properties.SetVector(mOfsBID, settings.speedB.value * t);

            context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
        }
    }
}