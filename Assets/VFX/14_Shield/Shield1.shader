Shader "MineselfShader/VFX/14-Shield/Shield1"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        [HDR]_EdgeColor("EdgeColor", COLOR) = (1,1,1,1)
        _EdgeWidth("EdgeWidth", Float) = 1
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
            #include "..\..\_Common\MyLib.cginc"
			
            //��������
            sampler2D _CameraDepthTexture;

            sampler2D _MainTex;
            fixed4 _EdgeColor;
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
                float4 screenPos : TEXCOORD1;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = v.uv;
                o.screenPos = ComputeScreenPos(o.pos);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.uv);

                //ʹ�÷�װ�õĺ��������Ե����
                float edgeMask = ComputeEdge(i.screenPos, _CameraDepthTexture, _EdgeWidth);

                float3 finalRGB = lerp(_EdgeColor, mainTex.rgb, edgeMask);

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}