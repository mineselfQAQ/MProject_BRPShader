Shader "MineselfShader/VFX/3-Dissolve/Dissolve_SoftLight"
{
    Properties
    {
        [NoScaleOffset]_MainTex("MainTexture", 2D) = "white"{}
        [NoScaleOffset]_NoiseTex("NoiseTexture", 2D) = "white"{}
        [Space(10)]
        [IntRange]_TimeSwitch("TimeSwitch", Range(0, 1)) = 0
        _Int("NoiseIntensity", Range(0, 1)) = 0
        [HDR]_EdgeCol("EdgeColor", COLOR) = (1,1,1,1)
        _EdgeWidth("EdgeWidth", Range(0, 1)) = 0.2
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

			
            //��������
            sampler2D _MainTex;
            sampler2D _NoiseTex;
            float _TimeSwitch;
            float _Int;
            fixed4 _EdgeCol;
            float _EdgeWidth;
                
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

                //����ʱ��
                //ͨ��_Time�ٿ�ʱʹ�õ������Բ�������������ͼһ����˵�������ȣ��������ȿ�����ĸо�
                float t = lerp(_Int, frac(_Time.y * _Int), _TimeSwitch);

                //���ܽ�
                //������Ҫʹ��smoothstep()����ֵ������[0,1]---����ͨ��saturate()�����Ը�ǿ
                noiseMask = noiseMask + 1 + t * -2;
                noiseMask = smoothstep(0, _EdgeWidth, noiseMask);

                //����---noiseMask���1��0�仯��������Ҫ��ʧʱ���ͻ���ʾa-��ɫ��Ȼ����ʧ
                float3 finalRGB = lerp(_EdgeCol, mainTex, noiseMask);
                float alpha = noiseMask * mainTex.a;//ע�������Ҫ�޳�����ͼΪ0�Ĳ��֣���Ҫ�޳����������Ͳ�Ҫ�Ĳ���

                return float4(finalRGB, alpha);
            }
            ENDCG
        }
    }
    Fallback Off
}