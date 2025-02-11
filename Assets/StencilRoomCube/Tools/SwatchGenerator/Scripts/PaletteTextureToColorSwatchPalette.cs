using System.Collections.Generic;
using UnityEngine;

#if UNITY_EDITOR
using UnityEditor;
#endif

public class SwatchPaletteManager : MonoBehaviour
{
    public enum SwatchSortMode
    {
        Hue,
        Brightness,
        Saturation
    }

    [Header("Swatch Configuration")]
    public SwatchSortMode sortMode = SwatchSortMode.Hue;
    public List<Color> colors = new List<Color>();

#if UNITY_EDITOR
    [ContextMenu("Build Swatch Palette")]
    public void BuildSwatchPalette()
    {
        switch (sortMode)
        {
            case SwatchSortMode.Hue:
                colors.Sort((a, b) => a.GetHue().CompareTo(b.GetHue()));
                break;
            case SwatchSortMode.Brightness:
                colors.Sort((a, b) => a.GetBrightness().CompareTo(b.GetBrightness()));
                break;
            case SwatchSortMode.Saturation:
                colors.Sort((a, b) => a.GetSaturation().CompareTo(b.GetSaturation()));
                break;
        }

        Debug.Log("Swatch palette built successfully.");
    }
#endif

    private void Start()
    {
        if (Application.isPlaying)
        {
            Debug.Log("Swatch palette manager initialized.");
        }
    }
}

public static class ColorExtensions
{
    public static float GetHue(this Color color)
    {
        Color.RGBToHSV(color, out float hue, out _, out _);
        return hue;
    }

    public static float GetBrightness(this Color color)
    {
        return color.maxColorComponent;
    }

    public static float GetSaturation(this Color color)
    {
        Color.RGBToHSV(color, out _, out float saturation, out _);
        return saturation;
    }
}
