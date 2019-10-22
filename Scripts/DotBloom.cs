using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

namespace M8.PostProcessEffects {
    [System.Serializable]
    [PostProcess(typeof(ScalerRenderer), PostProcessEvent.AfterStack, "M8/Scale/DotBloom")]
    public class DotBloom : ScalerBase {
        public FloatConstantParameter blend = new FloatConstantParameter() { value = 0.65f };
        public FloatConstantParameter gamma = new FloatConstantParameter() { value = 2.4f };
        public FloatConstantParameter shine = new FloatConstantParameter() { value = 0.05f };

        public override string shaderPath { get { return "Hidden/M8/PostProcessEffects/DotBloom"; } }

        private int mBlendID;
        private int mGammaID;
        private int mShineID;

        public override void Init() {
            mBlendID = Shader.PropertyToID("blend");
            mGammaID = Shader.PropertyToID("gamma");
            mShineID = Shader.PropertyToID("shine");
        }

        public override void ApplySettings(MaterialPropertyBlock properties) {
            properties.SetFloat(mBlendID, blend);
            properties.SetFloat(mGammaID, gamma);
            properties.SetFloat(mShineID, shine);
        }
    }
}