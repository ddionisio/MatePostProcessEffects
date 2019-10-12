using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

namespace M8.PostProcessEffects {
    [System.Serializable]
    [PostProcess(typeof(TileRenderer), PostProcessEvent.BeforeStack, "M8/Tile")]
    public class Tile : PostProcessEffectSettings {
        public IntParameter numTiles = new IntParameter() { value = 1024 };
    }

    public class TileRenderer : PostProcessEffectRenderer<Tile> {
        private Shader mShader;

        private int mNumTilesID;

        public override void Init() {
            mShader = Shader.Find("Hidden/M8/PostProcessEffects/Tile");

            mNumTilesID = Shader.PropertyToID("numTiles");
        }

        public override void Render(PostProcessRenderContext context) {
            var sheet = context.propertySheets.Get(mShader);

            sheet.properties.SetFloat(mNumTilesID, settings.numTiles);

            context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
        }
    }
}