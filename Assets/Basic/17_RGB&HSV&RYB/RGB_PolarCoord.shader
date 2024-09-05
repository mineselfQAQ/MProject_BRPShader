Shader "MineselfShader/Basic/17-RGB&HSV&RYB/RGB_PolarCoord"
{
    Properties
    {
        _Value("Value", Range(0, 1)) = 1
        _Rotation("Rotation", Range(0, 1)) = 0
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
            float _Value;
            float _Rotation;
                
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
                //首先先获得角度和半径
                float2 polarParams = Rect2Polar(i.uv, float2(0.5, 0.5));
                //通过角度来控制色相，半径来控制饱和度，来获得极坐标形式
                float3 finalRGB = HSV2RGB(float3(polarParams.x + 0.5 + _Rotation, polarParams.y, _Value));

                float alpha = step(polarParams.y, 1);//剔除，成为色轮

                return float4(finalRGB, alpha);
            }
            ENDCG
        }
    }
    Fallback Off
}