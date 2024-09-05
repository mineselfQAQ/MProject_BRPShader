using UnityEngine;

public class ColorCycle2 : MonoBehaviour
{
    public Material mat;
    public Color Color = Color.white;
    public float CycleSpeed = 1;

    private float large;
    private float small;

    void Update()
    {
        //求RGB中最小的和最大的
        if (Color.r >= Color.g)
        {
            large = Color.r;
            small = Color.g;
            if (Color.b >= Color.r)
                large = Color.b;
            if (Color.b <= Color.g)
                small = Color.b;
        }
        else
        {
            large = Color.g;
            small = Color.r;
            if (Color.b >= Color.g)
                large = Color.b;
            if (Color.b <= Color.r)
                small = Color.b;
        }

        //将RGB限制在(small,large)
        if (Color.r > large)
            Color.r = large;
        if (Color.r < small)
            Color.r = small;
        if (Color.g > large)
            Color.g = large;
        if (Color.g < small)
            Color.g = small;
        if (Color.b > large)
            Color.b = large;
        if (Color.b < small)
            Color.b = small;

        //基础循环
        if (Color.r >= Color.g && Color.g >= Color.b)
            Color.g += Time.deltaTime * CycleSpeed;
        if (Color.g >= Color.r && Color.r >= Color.b)
            Color.r -= Time.deltaTime * CycleSpeed;
        if (Color.g >= Color.b && Color.b >= Color.r)
            Color.b += Time.deltaTime * CycleSpeed;
        if (Color.b >= Color.g && Color.g >= Color.r)
            Color.g -= Time.deltaTime * CycleSpeed;
        if (Color.b >= Color.r && Color.r >= Color.g)
            Color.r += Time.deltaTime * CycleSpeed;
        if (Color.r >= Color.b && Color.b >= Color.g)
            Color.b -= Time.deltaTime * CycleSpeed;

        mat.SetColor("_Color", Color);
    }
}