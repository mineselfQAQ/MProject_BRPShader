Shader "MineselfShader/VFX/14-Shield/Shield2"
{
    Properties
    {
        [HDR]_EdgeColor("EdgeColor", COLOR) = (1,1,1,1)
        _EdgeWidth("EdgeWidth", Float) = 1
        _FresnelPow("FresnelPow", Range(0, 10)) = 3
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
            Cull Off
            Blend One One
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //��������ļ�����ָ��
            #include "..\..\_Common\MyLib.cginc"
			
            //��������
            sampler2D _CameraDepthTexture;

            fixed4 _EdgeColor;
            float _EdgeWidth;
            float _FresnelPow;
                
			//��������
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
			
            //�������
            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 screenPos : TEXCOORD0;
                float3 wNormal : TEXCOORD1;
                float4 wPos : TEXCOORD2;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.screenPos = ComputeScreenPos(o.pos);

                o.wNormal = normalize(UnityObjectToWorldNormal(v.normal));
                o.wPos = mul(unity_ObjectToWorld, v.vertex);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i, fixed face : VFACE) : SV_Target
            {
                //����Fresnel
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));
                float fresnel = pow(1 - saturate(dot(vDir, i.wNormal)), _FresnelPow);
                fresnel = face > 0 ? fresnel : 0;//���ڱ��棬fresnelʹ��0---Ҳ���ǲ�ʹ��

                //ʹ�÷�װ�õĺ��������Ե����
                float edgeMask = ComputeEdge(i.screenPos, _CameraDepthTexture, _EdgeWidth);
                edgeMask = 1 - edgeMask;

                float3 finalRGB = _EdgeColor * (edgeMask + fresnel);

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}