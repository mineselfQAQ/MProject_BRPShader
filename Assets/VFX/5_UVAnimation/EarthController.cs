using UnityEngine;
using UnityEngine.UI;

public class EarthController : MonoBehaviour
{
    public Material mat;
    public Slider slider;

    private void OnApplicationQuit()
    {
        mat.SetFloat("_Control", 0);
    }

    public void EarthSlider()
    {
        mat.SetFloat("_Control", slider.value);
    }
}
