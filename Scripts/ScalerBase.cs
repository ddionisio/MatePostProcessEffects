using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

namespace M8.PostProcessEffects {
    public abstract class ScalerBase : PostProcessEffectSettings {
        public IntConstantParameter resolutionWidth = new IntConstantParameter() { value = 320 };
        public IntConstantParameter resolutionHeight = new IntConstantParameter() { value = 180 };
        public FilterModeParameter filterMode = new FilterModeParameter() { value = FilterMode.Point };

        public abstract string shaderPath { get; }

        public abstract void Init();

        public abstract void ApplySettings(MaterialPropertyBlock properties);
    }

    public class ScalerRenderer : PostProcessEffectRenderer<ScalerBase> {
        private Shader mShader;

        public override void Init() {            
            mShader = Shader.Find(settings.shaderPath);

            settings.Init();
        }

        public override void Render(PostProcessRenderContext context) {
            var sheet = context.propertySheets.Get(mShader);

            settings.ApplySettings(sheet.properties);

            var cmd = context.command;

            var rt = context.GetScreenSpaceTemporaryRT(0, RenderTextureFormat.Default, RenderTextureReadWrite.Default, settings.resolutionWidth, settings.resolutionHeight);
            rt.filterMode = settings.filterMode;

            cmd.BlitFullscreenTriangle(context.source, rt);

            cmd.BlitFullscreenTriangle(rt, context.destination, sheet, 0);

            RenderTexture.ReleaseTemporary(rt);
        }
    }
}