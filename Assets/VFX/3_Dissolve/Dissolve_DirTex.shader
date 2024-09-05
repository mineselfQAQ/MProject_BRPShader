Shader "MineselfShader/VFX/3-Dissolve/Dissolve_DirTex"
{
    Properties
    {
        [NoScaleOffset]_MainTex("MainTexture", 2D) = "white"{}
        [NoScaleOffset]_NoiseTex("NoiseTexture", 2D) = "white"{}
        [NoScaleOffset]_DirTex("DirectionTexture", 2D) = "white"{}
        [Space(10)]
        [IntRange]_TimeSwitch("TimeSwitch", Range(0, 1)) = 0
        _Int("Manual:NoiseIntensity", Range(0, 1)) = 0
        _Speed("Auto:Speed", Float) = 0.5
        [Space(10)]
        _Scale("Scale", Float) = 1
        _Start("Start", Float) = 0
        _End("End", Float) = 1
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
            //��Ⱦ״̬
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha//�����ܽ���˵������ʲ���Ҫ�뱳����ϵĸо������Բ���AD��AB
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //��������ļ�����ָ��
            #include "..\..\_Common\MyLib.cginc"
			
            //��������
            sampler2D _MainTex;
            sampler2D _NoiseTex;
            sampler2D _DirTex;
            float _TimeSwitch;
            float _Int;
            float _Speed;
            float _Scale;
            float _Start;
            float _End;
                
			//��������
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
			
            //�������
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = v.uv;

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.uv);
                float noiseMask = tex2D(_NoiseTex, i.uv);
                float dirMask = tex2D(_DirTex, i.uv);

                //����ʱ��
                _Int = Remap(_Int, 0, 1, _Start, _End);
                float t = lerp(_Int, frac(_Time.y * _Speed) * (_End - _Start) + _Start, _TimeSwitch);

                //ʹ��dirMask��ӷ�����
                noiseMask = step(t, noiseMask + dirMask * _Scale);

                float3 finalRGB = mainTex;
                float alpha = noiseMask * mainTex.a;//ע�������Ҫ�޳�����ͼΪ0�Ĳ��֣���Ҫ�޳����������Ͳ�Ҫ�Ĳ���

                return float4(finalRGB, alpha);
            }
            ENDCG
        }
    }
    Fallback Off
}