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
        Color.RGBToHSV(Color, out H, out S, out V);//�ú����Ĺ̶���ʽ---1����3���
    }

    void Update()
    {
        //����Ϊ1�����Թ���1Ӧ�ñ��0
        if (H >= 1)
            H = 0;
        //H��ʱ��任
        H += Time.deltaTime * cycleSpeed;

        finalColor = Color.HSVToRGB(H, S, V);
        mat.SetColor("_Color", finalColor);
    }
}
