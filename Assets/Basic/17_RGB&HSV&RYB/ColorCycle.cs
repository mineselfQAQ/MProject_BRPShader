using UnityEngine;

public class ColorCycle : MonoBehaviour
{
    public Material mat;
    public Color Color = Color.white;
    public float cycleSpeed = 1;

    private float H, S, V;
    private Color finalColor;

    void Start()
    {
        Color.RGBToHSV(Color, out H, out S, out V);//该函数的固定形式---1输入3输出
    }

    void Update()
    {
        //周期为1，所以过了1应该变回0
        if (H >= 1)
            H = 0;
        //H随时间变换
        H += Time.deltaTime * cycleSpeed;

        finalColor = Color.HSVToRGB(H, S, V);
        mat.SetColor("_Color", finalColor);
    }
}
