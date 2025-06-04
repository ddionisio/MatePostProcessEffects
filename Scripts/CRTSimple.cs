using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

namespace M8.PostProcessEffects {
	[System.Serializable]
	[PostProcess(typeof(CRTSimpleRenderer), PostProcessEvent.AfterStack, "M8/CRT/Simple")]
	public class CRTSimple : PostProcessEffectSettings {
		[Range(1f, 10f)]
		public FloatParameter curvature = new FloatParameter() { value = 10f };

		[Range(1f, 100f)]
		public FloatParameter vignette = new FloatParameter() { value = 30f };
	}

	public class CRTSimpleRenderer : PostProcessEffectRenderer<CRTSimple> {
		private Shader mShader;

		private int mCurvatureID;
		private int mVignetteID;

		public override void Init() {
			mShader = Shader.Find("Hidden/M8/PostProcessEffects/CRTSimple");

			mCurvatureID = Shader.PropertyToID("curvature");
			mVignetteID = Shader.PropertyToID("vignetteWidth");
		}

		public override void Render(PostProcessRenderContext context) {
			var sheet = context.propertySheets.Get(mShader);

			sheet.properties.SetFloat(mCurvatureID, settings.curvature);
			sheet.properties.SetFloat(mVignetteID, settings.vignette);

			context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
		}
	}
}