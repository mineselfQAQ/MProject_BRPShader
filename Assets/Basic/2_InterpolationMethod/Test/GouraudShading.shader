Shader "MineselfShader/Test/GouraudShading"
{
    Properties
    {
        _Gloss("Gloss", Range(1, 100)) = 30
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
            float _Gloss;
                
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
                float4 color : COLOR;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                float3 wNormal = normalize(UnityObjectToWorldNormal(v.normal));
                float3 wvDir = normalize(WorldSpaceViewDir(v.vertex));
                float3 wlDir = normalize(WorldSpaceLightDir(v.vertex));
                float3 wrlDir = normalize(reflect(-wlDir, wNormal));

                float diffuse = saturate(dot(wNormal, wlDir));
                float specular = pow(saturate(dot(wvDir, wrlDir)), _Gloss);

                o.color = (diffuse + specular).rrrr;

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float3 finalRGB = i.color;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}