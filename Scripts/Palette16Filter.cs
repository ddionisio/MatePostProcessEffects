using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

namespace M8.PostProcessEffects {
    [System.Serializable]
    [PostProcess(typeof(Palette16FilterRenderer), PostProcessEvent.AfterStack, "M8/Palette 16 Filter")]
    public class Palette16Filter : PostProcessEffectSettings {
        public FloatConstantParameter enhance = new FloatConstantParameter() { value = 1.2f };

        public ColorConstantParameter color1 = new ColorConstantParameter() { value = Color.white };
        public ColorConstantParameter color2 = new ColorConstantParameter() { value = Color.white };
        public ColorConstantParameter color3 = new ColorConstantParameter() { value = Color.white };
        public ColorConstantParameter color4 = new ColorConstantParameter() { value = Color.white };
        public ColorConstantParameter color5 = new ColorConstantParameter() { value = Color.white };
        public ColorConstantParameter color6 = new ColorConstantParameter() { value = Color.white };
        public ColorConstantParameter color7 = new ColorConstantParameter() { value = Color.white };
        public ColorConstantParameter color8 = new ColorConstantParameter() { value = Color.white };
        public ColorConstantParameter color9 = new ColorConstantParameter() { value = Color.white };
        public ColorConstantParameter color10 = new ColorConstantParameter() { value = Color.white };
        public ColorConstantParameter color11 = new ColorConstantParameter() { value = Color.white };
        public ColorConstantParameter color12 = new ColorConstantParameter() { value = Color.white };
        public ColorConstantParameter color13 = new ColorConstantParameter() { value = Color.white };
        public ColorConstantParameter color14 = new ColorConstantParameter() { value = Color.white };
        public ColorConstantParameter color15 = new ColorConstantParameter() { value = Color.white };
        public ColorConstantParameter color16 = new ColorConstantParameter() { value = Color.white };
    }

    public class Palette16FilterRenderer : PostProcessEffectRenderer<Palette16Filter> {
        private Shader mShader;

        private int mEnhanceID;
        private int mColor1ID;
        private int mColor2ID;
        private int mColor3ID;
        private int mColor4ID;
        private int mColor5ID;
        private int mColor6ID;
        private int mColor7ID;
        private int mColor8ID;
        private int mColor9ID;
        private int mColor10ID;
        private int mColor11ID;
        private int mColor12ID;
        private int mColor13ID;
        private int mColor14ID;
        private int mColor15ID;
        private int mColor16ID;

        public override void Init() {
            mShader = Shader.Find("Hidden/M8/PostProcessEffects/Palette16Filter");

            mEnhanceID = Shader.PropertyToID("enhance");
            mColor1ID = Shader.PropertyToID("color0");
            mColor2ID = Shader.PropertyToID("color1");
            mColor3ID = Shader.PropertyToID("color2");
            mColor4ID = Shader.PropertyToID("color3");
            mColor5ID = Shader.PropertyToID("color4");
            mColor6ID = Shader.PropertyToID("color5");
            mColor7ID = Shader.PropertyToID("color6");
            mColor8ID = Shader.PropertyToID("color7");
            mColor9ID = Shader.PropertyToID("color8");
            mColor10ID = Shader.PropertyToID("color9");
            mColor11ID = Shader.PropertyToID("color10");
            mColor12ID = Shader.PropertyToID("color11");
            mColor13ID = Shader.PropertyToID("color12");
            mColor14ID = Shader.PropertyToID("color13");
            mColor15ID = Shader.PropertyToID("color14");
            mColor16ID = Shader.PropertyToID("color15");
        }

        public override void Render(PostProcessRenderContext context) {
            var sheet = context.propertySheets.Get(mShader);

            sheet.properties.SetFloat(mEnhanceID, settings.enhance);

            sheet.properties.SetColor(mColor1ID, settings.color1);
            sheet.properties.SetColor(mColor2ID, settings.color2);
            sheet.properties.SetColor(mColor3ID, settings.color3);
            sheet.properties.SetColor(mColor4ID, settings.color4);
            sheet.properties.SetColor(mColor5ID, settings.color5);
            sheet.properties.SetColor(mColor6ID, settings.color6);
            sheet.properties.SetColor(mColor7ID, settings.color7);
            sheet.properties.SetColor(mColor8ID, settings.color8);
            sheet.properties.SetColor(mColor9ID, settings.color9);
            sheet.properties.SetColor(mColor10ID, settings.color10);
            sheet.properties.SetColor(mColor11ID, settings.color11);
            sheet.properties.SetColor(mColor12ID, settings.color12);
            sheet.properties.SetColor(mColor13ID, settings.color13);
            sheet.properties.SetColor(mColor14ID, settings.color14);
            sheet.properties.SetColor(mColor15ID, settings.color15);
            sheet.properties.SetColor(mColor16ID, settings.color16);

            context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
        }
    }
}