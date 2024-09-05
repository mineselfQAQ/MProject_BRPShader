Shader "MineselfShader/VFX/3-Dissolve/Dissolve_Orientation"
{
    Properties
    {
        [NoScaleOffset]_MainTex("MainTexture", 2D) = "white"{}
        [NoScaleOffset]_NoiseTex("NoiseTexture", 2D) = "white"{}
        [Space(10)]
        [IntRange]_TimeSwitch("TimeSwitch", Range(0, 1)) = 0
        _Int("Manual:NoiseIntensity", Range(0, 1)) = 0
        _Speed("Auto:Speed", Float) = 0.5
        [Space(10)]
        _Scale("Scale", Float) = 1
        _Start("Start", Float) = 0
        _End("End", Float) = 1
        _DissolveDir("DissolveDirection", Vector) = (0,1,0,0)
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
			#include "..\..\_Common\MyLib.cginc"

            //变量申明
            sampler2D _MainTex;
            sampler2D _NoiseTex;
            float _TimeSwitch;
            float _Int;
            float _Speed;
            float _Scale;
            float _Start;
            float _End;
            float3 _DissolveDir;
                
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
                float wFactor : TEXCOORD1;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = v.uv;

                float4 wPos = mul(unity_ObjectToWorld, v.vertex);
                //计算世界空间物体原点的两种方法
                float3 pivot = mul(unity_ObjectToWorld, float4(0,0,0,1));
                //float3 pivot = float3(unity_ObjectToWorld[0].w, unity_ObjectToWorld[1].w, unity_ObjectToWorld[2].w);
                float3 pos = wPos.rgb - pivot;
                float posOffset = dot(normalize(_DissolveDir), pos);
                o.wFactor = posOffset;

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.uv);
                float noiseMask = tex2D(_NoiseTex, i.uv);

                //计算时间
                _Int = Remap(_Int, 0, 1, _Start, _End);
                float t = lerp(_Int, frac(_Time.y * _Speed) * (_End - _Start) + _Start, _TimeSwitch);
                
                //方向性溶解核心---根据物体原点到物体顶点的向量与目标向量的点积决定，也就是i.wFactor
                noiseMask = step(t, noiseMask + i.wFactor * _Scale);

                float3 finalRGB = mainTex;
                float alpha = noiseMask * mainTex.a;//注意除了需要剔除噪声图为0的部分，还要剔除主纹理本来就不要的部分

                return float4(finalRGB, alpha);
            }
            ENDCG
        }
    }
    Fallback Off
}