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
            //��Ⱦ״̬
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //��������ļ�����ָ��

			
            //��������
            sampler2D _MainTex;
            sampler2D _NoiseTex;
            float _NoiseInt;
            float2 _Speed;
            float _Offset;
                
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
                float2 uv2 : TEXCOORD1;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                //uv---����������  uv2---��������ͼ����
                o.uv = v.uv;
                o.uv2 = v.uv + frac(_Time.x * _Speed);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                //д��1---ʹ��lerp()    ���ڻ����ŵ�����
                //float noiseMask = tex2D(_NoiseTex, i.uv2);
                //i.uv = lerp(i.uv, noiseMask. - _Offset, _NoiseInt);
                //float4 mainTex = tex2D(_MainTex, i.uv);

                //д��2---ֱ��λ��uv  ���õĽⷨ
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
