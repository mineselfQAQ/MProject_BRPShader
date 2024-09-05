Shader "MineselfShader/Basic/3-Texture/ThreeColorWithAO"
{
    Properties
    {
        _AO("AO", 2D) = "white"{}
        _TopCol("TopColor", COLOR) = (1,1,1,1)
        _SideCol("SideColor", COLOR) = (0.9,0.9,0.9,1)
        _BottomCol("BottomColor", COLOR) = (0.8,0.8,0.8,1)
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
            sampler2D _AO; float4 _AO_ST;
            fixed4 _TopCol;
            fixed4 _SideCol;
            fixed4 _BottomCol;

			//��������
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };
			
            //�������
            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 wNormal : TEXCOORD0;
                float2 uv : TEXCOORD1;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wNormal = UnityObjectToWorldNormal(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _AO);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                //���ֵĺ���:����ռ䷨��
                float3 nDir = normalize(i.wNormal);

                //��������������
                //���������ֺ������ֺܺü��㣬ֻ��ͨ������ռ䷨�߼���֪�����Ӧ�Ĳ���
                //��������ʵ���ǳ�����/�����ֵ�ʣ�ಿ�֣�ֻ��ʹ��һ�����㼴��
                float topMask = saturate(nDir.y);
                float bottomMask = saturate(-nDir.y);
                float sideMask = 1 - topMask - bottomMask;

                float3 finalRGB = _TopCol * topMask +
                                  _SideCol * sideMask +
                                  _BottomCol * bottomMask;
                
                //����AO��ͼ
                float4 ao = tex2D(_AO, i.uv);
                finalRGB *= ao;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}