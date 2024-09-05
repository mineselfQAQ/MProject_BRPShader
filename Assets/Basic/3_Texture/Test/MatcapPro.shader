Shader "MineselfShader/Test/MatcapPro"
{
    Properties
    {
        _Matcap("Matcap", 2D) = "white"{}
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
            sampler2D _Matcap;
                
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
                float2 uv : TEXCOORD0;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                float3 vNormal = normalize(mul(UNITY_MATRIX_IT_MV, v.normal));
                float3 vPos = normalize(UnityObjectToViewPos(v.vertex));

                float3 crossResult = cross(vPos, vNormal);

                o.uv = float2(-crossResult.y, crossResult.x) * 0.5 + 0.5;

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_Matcap, i.uv);

                return mainTex;
            }
            ENDCG
        }
    }
    Fallback Off
}