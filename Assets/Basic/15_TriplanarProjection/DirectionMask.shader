Shader "MineselfShader/Basic/15-TriplanarProjection/DirectionMask"
{
    Properties
    {
        _Sharpness("Sharpness", Range(1, 128)) = 32
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
            float _Sharpness;
                
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
                float3 wNormal : TEXCOORD0;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wNormal = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float3 nDir = normalize(i.wNormal);
                //�񻯱�Ե
                nDir = pow(abs(nDir), _Sharpness);
                nDir /= dot(nDir, float3(1,1,1));
                //�ٴμ�ǿ��
                nDir = round(nDir);

                return float4(nDir, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}