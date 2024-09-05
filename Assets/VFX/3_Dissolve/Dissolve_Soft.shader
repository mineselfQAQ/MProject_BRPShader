Shader "MineselfShader/VFX/3-Dissolve/Dissolve_Soft"
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
            Blend SrcAlpha OneMinusSrcAlpha//对于溶解来说，大概率不需要与背景混合的感觉，所以不用AD用AB
            
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

                //软溶解算法
                //noiseMask为[0,1]，t也是[0,1]
                //noiseMask+1后为[1,2]，这是默认情况---没有溶解
                //当t慢慢变大，开始溶解，直到t=1时，取值范围[-1,0]，完全溶解
                noiseMask = saturate(noiseMask + 1 + t * -2);

                float3 finalRGB = mainTex;
                float alpha = noiseMask * mainTex.a;//注意除了需要剔除噪声图为0的部分，还要剔除主纹理本来就不要的部分

                return float4(finalRGB, alpha);
            }
            ENDCG
        }
    }
    Fallback Off
}