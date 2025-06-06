using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

namespace M8.PostProcessEffects {
	[System.Serializable]
	[PostProcess(typeof(ZoomRenderer), PostProcessEvent.BeforeStack, "M8/Zoom")]
	public class Zoom : PostProcessEffectSettings {
		public Vector2Parameter center = new Vector2Parameter() { value = new Vector2(0.5f, 0.5f) };
		public FloatParameter amount = new FloatParameter() { value = 1f };
	}

	public class ZoomRenderer : PostProcessEffectRenderer<Zoom> {
		private Shader mShader;

		private int mParmsID;

		public override void Init() {
			mShader = Shader.Find("Hidden/M8/PostProcessEffects/Zoom");

			mParmsID = Shader.PropertyToID("parms");
		}

		public override void Render(PostProcessRenderContext context) {
			var sheet = context.propertySheets.Get(mShader);

			Vector2 center = settings.center;

			sheet.properties.SetVector(mParmsID, new Vector4(center.x, center.y, settings.amount));

			context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
		}
	}
}