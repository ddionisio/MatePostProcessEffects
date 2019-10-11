using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

namespace M8.PostProcessEffects {
    [System.Serializable]
    [PostProcess(typeof(Palette4FilterRenderer), PostProcessEvent.AfterStack, "M8/Palette 4 Filter")]
    public class Palette4Filter : PostProcessEffectSettings {
        public FloatConstantParameter enhance = new FloatConstantParameter() { value = 1.2f };

        public ColorConstantParameter color1 = new ColorConstantParameter() { value = Color.white };
        public ColorConstantParameter color2 = new ColorConstantParameter() { value = Color.white };
        public ColorConstantParameter color3 = new ColorConstantParameter() { value = Color.white };
        public ColorConstantParameter color4 = new ColorConstantParameter() { value = Color.white };
    }

    public class Palette4FilterRenderer : PostProcessEffectRenderer<Palette4Filter> {
        private Shader mShader;

        private int mEnhanceID;
        private int mColor1ID;
        private int mColor2ID;
        private int mColor3ID;
        private int mColor4ID;

        public override void Init() {
            mShader = Shader.Find("Hidden/M8/PostProcessEffects/Palette4Filter");

            mEnhanceID = Shader.PropertyToID("enhance");
            mColor1ID = Shader.PropertyToID("color0");
            mColor2ID = Shader.PropertyToID("color1");
            mColor3ID = Shader.PropertyToID("color2");
            mColor4ID = Shader.PropertyToID("color3");
        }

        public override void Render(PostProcessRenderContext context) {
            var sheet = context.propertySheets.Get(mShader);

            sheet.properties.SetFloat(mEnhanceID, settings.enhance);

            sheet.properties.SetColor(mColor1ID, settings.color1);
            sheet.properties.SetColor(mColor2ID, settings.color2);
            sheet.properties.SetColor(mColor3ID, settings.color3);
            sheet.properties.SetColor(mColor4ID, settings.color4);

            context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
        }
    }
}