Shader "MineselfShader/VFX/3-Dissolve/Clip_Hard"
{
    Properties
    {
        [NoScaleOffset]_MainTex("MainTexture", 2D) = "white"{}
        [NoScaleOffset]_NoiseTex("NoiseTexture", 2D) = "white"{}
        [Space(10)]
        [IntRange]_TimeSwitch("TimeSwitch", Range(0, 1)) = 0
        _Int("NoiseIntensity", Range(0, 1)) = 0
    }
    SubShader
    {
        //SubShader Tags
		Tags
        {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
            "ForceNoShadowCasting"="True"
            "IgnoreProjector"="True"
        }
        Pass
        {
            //Pass Tags
            Tags{}
            //渲染状态
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //额外包含文件编译指令

			
            //变量申明
            sampler2D _MainTex;
            sampler2D _NoiseTex;
            float _TimeSwitch;
            float _Int;
                
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
                float4 mainTex = tex2D(_MainTex, i.uv);
                float noiseMask = tex2D(_NoiseTex, i.uv);

                //计算时间
                //通过_Time操控时使用的是线性操作，由于噪声图一般来说不够均匀，会有种先快后慢的感觉
                float t = lerp(_Int, frac(_Time.y * _Int), _TimeSwitch);

                //剔除方式的核心---使用clip()
                //其中由于a通道的值需要部分为1，剔除部分为0，反了，需要使用一减
                clip(noiseMask - t - (1 - mainTex.a));

                return mainTex;
            }
            ENDCG
        }
    }
    Fallback Off
}