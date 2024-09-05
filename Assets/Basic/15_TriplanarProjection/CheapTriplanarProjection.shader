Shader "MineselfShader/Basic/15-TriplanarProjection/CheapTriplanarProjection"
{
    Properties
    {
        [KeywordEnum(Normal, Pro)]_Mode("Mode", Float ) = 0
        _MainTex("MainTexture", 2D) = "white"{}
        [PowerSilder(3.0)]_Tilling("Tilling", Range(0.1, 10)) = 1
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
            #pragma shader_feature _MODE_NORMAL _MODE_PRO
			
            //��������
            sampler2D _MainTex;
            float _Tilling;
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
                float4 wPos : TEXCOORD0;
                float3 wNormal : TEXCOORD1;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wPos = mul(unity_ObjectToWorld,v.vertex);
                o.wNormal = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float3 nDir = normalize(i.wNormal);

                //��������---���ھ�����������ҵߵ�
                #if _MODE_PRO
                    float3 mask = sign(nDir) * float3(1, 1, -1);
                    float2 maskX = float2(mask.x, 1);
                    float2 maskY = float2(mask.y, 1);
                    float2 maskZ = float2(mask.z, 1);
                #endif

                //�񻯱�Ե
                nDir = pow(abs(nDir), _Sharpness);
                nDir /= dot(nDir, float3(1, 1, 1));
                //�ٴμ�ǿ��
                nDir = round(nDir);

                //�������ڲ�����uv---ÿ������ʹ��һ��ƽ����в���
                #if _MODE_NORMAL
                    float2 uv = lerp(i.wPos.xz, i.wPos.zy, nDir.x);
                    uv = lerp(uv, i.wPos.xy, nDir.z);
                #else
                    float2 uv = lerp(i.wPos.xz * maskY, i.wPos.zy * maskX, nDir.x);
                    uv = lerp(uv, i.wPos.xy * maskZ, nDir.z);
                #endif

                float3 mainTex = tex2D(_MainTex, uv * _Tilling);

                return float4(mainTex, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}