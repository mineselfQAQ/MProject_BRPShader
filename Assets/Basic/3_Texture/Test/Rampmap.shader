Shader "MineselfShader/Test/Rampmap"
{
    Properties
    {
        _Rampmap("Rampmap", 2D) = "white"{}
        _uvY("uvY", Range(0, 1)) = 0.5
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
            sampler2D _Rampmap;
            float _uvY;
                
			//��������
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };
			
            //�������
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 wNormal : TEXCOORD1;
                float4 wPos : TEXCOORD2;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = v.uv;

                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                o.wNormal = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float3 nDir = normalize(i.wNormal);
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));

                float halfLambert = dot(nDir, lDir) * 0.5 + 0.5;

                float2 uv = i.uv;
                uv.x = halfLambert;
                uv.y = _uvY;

                float3 rampmap = tex2D(_Rampmap, uv);

                float3 finalRGB = rampmap;
                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}