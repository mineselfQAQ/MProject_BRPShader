Shader "MineselfShader/Basic/17-RGB&HSV&RYB/RGB_ColorCycle"
{
    Properties
    {
        _Speed("Speed", Float) = 1
        _Saturate("Saturate", Range(0, 1)) = 1
        _Value("Value", Range(0, 1)) = 1
    }
    SubShader
    {
        //SubShader Tags
		Tags
        {
            "Queue"="Transparent"
            "RenderType"="Transparent"
            "ForceNoShadowCasting"="True"
            "IgnoreProjector"="True"
        }
        Pass
        {
            //Pass Tags
            Tags{}
            //渲染状态
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //额外包含文件编译指令
            #include "..\..\_Common\MyLib.cginc"
			
            //变量申明
            float _Speed;
            float _Saturate;
            float _Value;
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                
                o.uv = v.uv;

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float hue = frac(_Time.x * _Speed);
                float3 finalRGB = HSV2RGB(float3(hue, _Saturate, _Value));
                
                float2 polarParams = Rect2Polar(i.uv, float2(0.5, 0.5));
                float alpha = step(polarParams.y, 1);//剔除，成为色轮

                return float4(finalRGB, alpha);
            }
            ENDCG
        }
    }
    Fallback Off
}