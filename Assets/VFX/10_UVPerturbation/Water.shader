Shader "MineselfShader/VFX/10-uvPerturbation/Water"
{
    Properties
    {
        [NoScaleOffset]_FireTex("FireTexture", 2D) = "white"{}
        [NoScaleOffset]_NoiseTex("NoiseTexture", 2D) = "white"{}
        _MainParams("XY:MainScale ZW:MainSpeed", vector) = (1,1,0,0)
        _Noise1Params("X:Noise1Scale Y:Noise1Intensity ZW:Noise1Speed", vector) = (1,1,0,0)
        _Noise2Params("X:Noise2Scale Y:Noise2Intensity ZW:Noise2Speed", vector) = (1,1,0,0)
        _PerturbationInt("PerturbationIntensity", Range(0, 1)) = 1
    }
    SubShader
    {
        //SubShader Tags
		Tags{}
        Pass
        {
            //Pass Tags
            Tags{}
            //��Ⱦ״̬
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //��������ļ�����ָ��

			
            //��������
            sampler2D _FireTex;
            sampler2D _NoiseTex;
            float4 _MainParams;
            float4 _Noise1Params;
            float4 _Noise2Params;
            float _PerturbationInt;
                
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
                //���2��uv---ͨ��һ������ͼ����
                float2 maskUV1 = i.uv * _Noise1Params.x - frac(_Time.x * _Noise1Params.zw);
                float2 maskUV2 = i.uv * _Noise2Params.x - frac(_Time.x * _Noise2Params.zw);
                
                //uv����
                float noiseMask1 = tex2D(_NoiseTex, maskUV1);
                float noiseMask2 = tex2D(_NoiseTex, maskUV2);
                //�ϲ�����ͼ
                float finalMask = noiseMask1 * _Noise1Params.y + noiseMask2 * _Noise2Params.y;

                //ͨ������ͼ�ı�������uv
                float uvBias = finalMask * _PerturbationInt;
                float2 mainUV = i.uv * _MainParams.xy - frac(_Time.x * _MainParams.zw) + uvBias;

                float4 mainTex = tex2D(_FireTex, mainUV);

                return mainTex;
            }
            ENDCG
        }
    }
    Fallback Off
}