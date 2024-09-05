Shader "MineselfShader/VFX/10-uvPerturbation/uvPerturbation"
{
    Properties
    {
        _MainTex("MainTexuture", 2D) = "white"{}
        _NoiseTex("NoiseTexture", 2D) = "white"{}
        _NoiseInt("NoiseIntensity", Float) = 0
        _Speed("Speed", vector) = (1,1,0,0)
        _Offset("Offset", Float) = 0
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

			
            //变量申明
            sampler2D _MainTex;
            sampler2D _NoiseTex;
            float _NoiseInt;
            float2 _Speed;
            float _Offset;
                
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

                //uv---用于主纹理  uv2---用于噪声图采样
                o.uv = v.uv;
                o.uv2 = v.uv + frac(_Time.x * _Speed);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                //写法1---使用lerp()    存在会缩放的问题
                //float noiseMask = tex2D(_NoiseTex, i.uv2);
                //i.uv = lerp(i.uv, noiseMask. - _Offset, _NoiseInt);
                //float4 mainTex = tex2D(_MainTex, i.uv);

                //写法2---直接位移uv  更好的解法
                float noiseMask = tex2D(_NoiseTex, i.uv2);
                float2 uvBias = (noiseMask - _Offset) * _NoiseInt;
                float4 mainTex = tex2D(_MainTex, i.uv + uvBias);

                return mainTex;
            }
            ENDCG
        }
    }
    Fallback Off
}
