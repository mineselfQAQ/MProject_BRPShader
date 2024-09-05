Shader "MineselfShader/VFX/9-PolarCoord/EdgeFlow"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        [HDR]_Color("Color", COLOR) = (1,1,1,1)
        [Toggle]_Invert("InvertDirection", Float) = 0
        _Speed("Speed", Float) = 1
        [Space(10)]
        _Scale("Scale", Float) = 1
        _Radius("Radius", Float) = 1
        _Width("Width", Range(0, 0.5)) = 0
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
			#pragma shader_feature _INVERT_ON

            //变量申明
            sampler2D _MainTex; float4 _MainTex_ST;
            fixed4 _Color;
            float _Speed;
            float _Scale;
            float _Radius;
            float _Width;
            
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
                
                //进行缩放操作，由于需要在贴图中心处缩放，所以需要先进行位移才行
                v.uv -= 0.5;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv += 0.5;

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float2 polarParms = Rect2Polar(i.uv, float2(0.5, 0.5));

                //控制方向，默认情况下应该是逆时针旋转，使用一减后就可以变为顺时针旋转
                #if _INVERT_ON
                  polarParms.x = 1 - polarParms.x;
                #endif
                //u---方向
                //核心为将方向旋转起来
                //这可以使用简单的旋转操作来做
                //这里使用的方法主要是frac()，查看frac()函数可视化就可以知道发生了什么
                float u = frac(frac(polarParms.x - (_Time.y * _Speed)) * _Scale);

                //v---远近
                //对于一般情况，我们只需要一个距离场，但是这里不是
                //我们需要将范围映射到一个中空环中
                //通过以下方法可以得到smoothV---中白外黑，夹在中间的smoothstep()过渡就是我们所要的区域
                float v = polarParms.y;
                float smoothV = 1 - smoothstep(0, _Radius, v);
                smoothV = Remap(smoothV, _Width, 1 - _Width, 0, 1);

                //我们只需要smoothV中0与1之间的过渡部分
                //这里求出用于a通道的值
                //注意：通过smoothV * (1 - smoothV)我们能得到过渡区域，此时过渡区域为一个比较小的值，其余都为0
                //     所以需要通过扩大后将其变为0与1---非黑即白
                float alphaMask = smoothV * (1 - smoothV);
                alphaMask = saturate(alphaMask * 10);

                //合并uv
                float2 polarUV = float2(u, smoothV);
                float4 mainTex = tex2D(_MainTex, polarUV);

                float3 finalRGB = mainTex.rgb * _Color;
                float alpha = mainTex.r * alphaMask;

                return float4(finalRGB, alpha);
            }
            ENDCG
        }
    }
    Fallback Off
}