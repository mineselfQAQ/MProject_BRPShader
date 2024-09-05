Shader "MineselfShader/VFX/2-UVFlow/UVFlow"
{
    Properties
    {
        [NoScaleOffset]_MainTex("MainTexture", 2D) = "white"{}
        [NoScaleOffset]_NoiseTex("NoiseTexture", 2D) = "white"{}
        [HDR]_Color("Color", COLOR) = (1,1,1,1)
        _Scale("XY:MainScale ZW:NoiseScale", vector) = (1,1,1,1)
        _Speed("XY:MainSpeed ZW:NoiseSpeed", vector) = (0,0,1,1)
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
            Blend One One
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //额外包含文件编译指令

			
            //变量申明
            sampler2D _MainTex;
            sampler2D _NoiseTex;
            fixed4 _Color;
            float4 _Scale;
            float4 _Speed;
                
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
                float2 uv2 : TEXCOORD1;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                //自行制作uv缩放与uv流动
                o.uv = v.uv * _Scale.xy + frac(_Time.x * _Speed.xy);
                o.uv2 = v.uv * _Scale.zw + frac(_Time.x * _Speed.zw);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                //采样贴图
                //主贴图认为是float4的，也就是说颜色信息被保留下来
                //噪声图认为是float的，只是用来添加流动效果
                float4 mainTex = tex2D(_MainTex, i.uv);
                float noiseMask = tex2D(_NoiseTex, i.uv2);

                //计算方式---相乘
                //两张贴图相乘，使用的是AD，0的区域剔除，这是正确的
                float3 finalRGB = _Color * mainTex * noiseMask;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}