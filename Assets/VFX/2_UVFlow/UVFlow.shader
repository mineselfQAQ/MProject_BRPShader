Shader "MineselfShader/VFX/2-UVFlow/UVFlow"
{
    Properties
    {
        [NoScaleOffset]_MainTex("MainTexture", 2D) = "white"{}
        [NoScaleOffset]_NoiseTex("NoiseTexture", 2D) = "white"{}
        [HDR]_Color("Color", COLOR) = (1,1,1,1)
        _Scale("XY:MainScale ZW:NoiseScale", vector) = (1,1,1,1)
        _Speed("XY:MainSpeed ZW:NoiseSpeed", vector) = (0,0,1,1)
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
            sampler2D _MainTex;
            sampler2D _NoiseTex;
            fixed4 _Color;
            float4 _Scale;
            float4 _Speed;
                
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

                //��������uv������uv����
                o.uv = v.uv * _Scale.xy + frac(_Time.x * _Speed.xy);
                o.uv2 = v.uv * _Scale.zw + frac(_Time.x * _Speed.zw);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                //������ͼ
                //����ͼ��Ϊ��float4�ģ�Ҳ����˵��ɫ��Ϣ����������
                //����ͼ��Ϊ��float�ģ�ֻ�������������Ч��
                float4 mainTex = tex2D(_MainTex, i.uv);
                float noiseMask = tex2D(_NoiseTex, i.uv2);

                //���㷽ʽ---���
                //������ͼ��ˣ�ʹ�õ���AD��0�������޳���������ȷ��
                float3 finalRGB = _Color * mainTex * noiseMask;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}