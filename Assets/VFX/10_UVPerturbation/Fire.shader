Shader "MineselfShader/VFX/10-uvPerturbation/Fire"
{
    Properties
    {
        [NoScaleOffset]_FireTex("FireTexture", 2D) = "white"{}
        [NoScaleOffset]_NoiseTex1("NoiseTexture1", 2D) = "white"{}
        [NoScaleOffset]_NoiseTex2("NoiseTexture2", 2D) = "white"{}
        _SpeedParams("XYZ:SpeedParams", vector) = (0,0,0,0)
        _ScaleParams("XYZ:ScaleParams", vector) = (1,1,1,0)
        _ColorInt("ColorIntensity", Range(0, 5)) = 1
        _PerturbationInt("PerturbationIntensity", Range(0, 1)) = 1
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
            Blend One One
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //��������ļ�����ָ��

			
            //��������
            sampler2D _FireTex;
            sampler2D _NoiseTex1;
            sampler2D _NoiseTex2;
            float3 _SpeedParams;
            float3 _ScaleParams;
            float _ColorInt;
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
                //���3��uv---2������ͼ1,1������ͼ2��������Ϊuv�������
                float2 maskUV1 = i.uv * _ScaleParams.x - frac(_Time.x * _SpeedParams.x);
                float2 maskUV2 = i.uv * _ScaleParams.y - frac(_Time.x * _SpeedParams.y);
                float2 maskUV3 = i.uv * _ScaleParams.z - frac(_Time.x * _SpeedParams.z);
                
                //uv����
                float noiseMask1 = tex2D(_NoiseTex1, maskUV1);
                float noiseMask2 = tex2D(_NoiseTex1, maskUV2);
                float noiseMask3 = tex2D(_NoiseTex2, maskUV3);
                //�ϲ�����ͼ
                float finalMask = noiseMask1 * noiseMask2 * noiseMask3;

                //ͨ������ͼ���������uv
                //i.uv = lerp(i.uv, finalMask * 10, _PerturbationInt);
                float uvBias = finalMask * _PerturbationInt;
                i.uv += uvBias;

                float4 mainTex = tex2D(_FireTex, i.uv) * _ColorInt;

                return mainTex;
            }
            ENDCG
        }
    }
    Fallback Off
}