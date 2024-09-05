Shader "MineselfShader/VFX/3-Dissolve/Dissolve_Axis"
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
        [KeywordEnum(X,Y,Z)]_Axis("Axis", Float) = 1
        [Toggle]_Invert("Invert", Float) = 0

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
            #pragma shader_feature _AXIS_X _AXIS_Y _AXIS_Z
            #pragma shader_feature _INVERT_ON
			
            //��������
            sampler2D _MainTex;
            sampler2D _NoiseTex;
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
                float4 oPos : TEXCOORD1;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = v.uv;
                o.oPos = v.vertex;

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.uv);
                float noiseMask = tex2D(_NoiseTex, i.uv);

                //����ʱ��
                _Int = Remap(_Int, 0, 1, _Start, _End);
                float t = lerp(_Int, frac(_Time.y * _Speed) * (_End - _Start) + _Start, _TimeSwitch);

                //��ת---�ϵ��¾ͻ����µ���
                #if _INVERT_ON
                  i.oPos = -i.oPos;
                #endif

                //�����ܽ����---�������嶥���������ԭ��������(����ĳһ����)
                #if _AXIS_X
                  noiseMask = step(t, noiseMask + i.oPos.x * _Scale);
                #elif _AXIS_Y
                  noiseMask = step(t, noiseMask + i.oPos.y * _Scale);
                #else
                  noiseMask = step(t, noiseMask + i.oPos.z * _Scale);
                #endif

                float3 finalRGB = mainTex;
                float alpha = noiseMask * mainTex.a;//ע�������Ҫ�޳�����ͼΪ0�Ĳ��֣���Ҫ�޳����������Ͳ�Ҫ�Ĳ���

                return float4(finalRGB, alpha);
            }
            ENDCG
        }
    }
    Fallback Off
}