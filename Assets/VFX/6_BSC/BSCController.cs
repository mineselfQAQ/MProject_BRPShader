using UnityEngine;
using UnityEngine.UI;

public class BSCController : MonoBehaviour
{
    public Material mat;

    public Slider slider1;
    public Slider slider2;
    public Slider slider3;

    private float b;
    private float s;
    private float c;

    private void Update()
    {
        b = slider1.value;
        s = slider2.value;
        c = slider3.value;
    }

    private void OnApplicationQuit()
    {
        mat.SetFloat("_Brightness", 1);
        mat.SetFloat("_Saturate", 1);
        mat.SetFloat("_Contrast", 1);
    }

    public void ChangeB()
    {
        mat.SetFloat("_Brightness", b);
    }
    public void ChangeS()
    {
        mat.SetFloat("_Saturate", s);
    }
    public void ChangeC()
    {
        mat.SetFloat("_Contrast", c);
    }
}
