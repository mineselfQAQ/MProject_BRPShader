Shader "MineselfShader/Instance/Crystal"
{
    Properties
    {
        [Header(Diffuse)][Space(5)]
        [HDR]_DiffCol("DiffuseColor", COLOR) = (1,1,1,1)
        
        [Header(Specular)][Space(5)]
        [HDR]_SpecCol("SpecularColor", COLOR) = (1,1,1,1)
        _Gloss("Gloss", Range(0, 100)) = 30

        [Header(Fresnel)][Space(5)]
        _FresnelPow("FresnelPower", Range(0, 10)) = 3
        [HDR]_BottomFresCol("BottomFresnelColor", COLOR) = (1,1,1,1)
        [HDR]_TopFresCol("TopFresnelColor", COLOR) = (1,1,1,1)
        _BottomRange("BottomRange", Range(0, 1)) = 0
        _TopRange("TopRange", Range(0, 1)) = 0
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
            fixed4 _DiffCol;

            fixed4 _SpecCol;
            float _Gloss;

            float _FresnelPow;
            fixed4 _BottomFresCol;
            fixed4 _TopFresCol;
            float _BottomRange;
            float _TopRange;
            
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
                float4 wPos : TEXCOORD1;
                float2 uv : TEXCOORD2;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wNormal = UnityObjectToWorldNormal(v.normal);
                o.wPos = mul(unity_ObjectToWorld, v.vertex);

                o.uv = v.uv;

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                //�����������
                float3 nDir = normalize(i.wNormal);
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                float3 rlDir = normalize(reflect(-lDir, nDir));
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));

                //�������---HalfLambert|Phong�߹�
                float3 diffuse = _DiffCol * (dot(lDir, nDir) * 0.5 + 0.6);
                float3 specular = _SpecCol * pow(saturate(dot(rlDir, vDir)), _Gloss);
                
                //����Fresnel---�ϲ�|�²�
                //ע�⣺һ����Ҫ����uv����ʹ�ø÷����������
                float bottomMask = smoothstep(i.uv.y, 1, _BottomRange);
                float topMask = smoothstep(1 - i.uv.y, 1, _TopRange);
                float fresnel = pow(1 - saturate(dot(nDir, vDir)), _FresnelPow);
                float3 bottomFresnel = bottomMask * fresnel * _BottomFresCol;
                float3 topFresnel = topMask * fresnel * _TopFresCol;
                float3 finalFresnel = topFresnel + bottomFresnel;

                float3 finalRGB = diffuse + specular + finalFresnel;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}