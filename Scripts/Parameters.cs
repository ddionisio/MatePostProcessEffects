using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

namespace M8.PostProcessEffects {
    [System.Serializable]
    public class IntConstantParameter : ParameterOverride<int> {
        public override void Interp(int from, int to, float t) {
            value = to;
        }
    }

    [System.Serializable]
    public class FloatConstantParameter : ParameterOverride<float> {
        public override void Interp(float from, float to, float t) {
            value = to;
        }
    }

    [System.Serializable]
    public class Vector2ConstantParameter : ParameterOverride<Vector2> {
        public override void Interp(Vector2 from, Vector2 to, float t) {
            value = to;
        }

        public static implicit operator Vector3(Vector2ConstantParameter prop) { return prop.value; }
        public static implicit operator Vector4(Vector2ConstantParameter prop) { return prop.value; }
    }

    [System.Serializable]
    public class Vector3ConstantParameter : ParameterOverride<Vector3> {
        public override void Interp(Vector3 from, Vector3 to, float t) {
            value = to;
        }

        public static implicit operator Vector2(Vector3ConstantParameter prop) { return prop.value; }
        public static implicit operator Vector4(Vector3ConstantParameter prop) { return prop.value; }
    }

    [System.Serializable]
    public class Vector4ConstantParameter : ParameterOverride<Vector4> {
        public override void Interp(Vector4 from, Vector4 to, float t) {
            value = to;
        }

        public static implicit operator Vector2(Vector4ConstantParameter prop) { return prop.value; }
        public static implicit operator Vector3(Vector4ConstantParameter prop) { return prop.value; }
    }

    [System.Serializable]
    public class ColorConstantParameter : ParameterOverride<Color> {
        public override void Interp(Color from, Color to, float t) {
            value = to;
        }
    }

    [System.Serializable]
    public class Texture2DConstantParameter : ParameterOverride<Texture2D> {
        public override void Interp(Texture2D from, Texture2D to, float t) {
            if(from)
                value = from;
            else if(to)
                value = to;
        }
    }
}
