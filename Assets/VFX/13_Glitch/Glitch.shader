Shader "MineselfShader/VFX/14-Glitch/ChannelGlitch"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        _OffsetParams("XY:Horizontal ZW:Vertical", vector) = (0,0,0,0)
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
            sampler2D _MainTex;
            float4 _OffsetParams;
                
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
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = v.uv;

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                //�̶�ͨ��G��Ҳ����˵��ɫͨ����Զ����������
                float4 mainTex1 = tex2D(_MainTex, i.uv);
                float G = mainTex1.g;

                //�ɱ�ͨ��RB�����ǿ��Խ���uv��ƫ��ʹͨ����λ�Ӷ���ù���Ч��
                float4 mainTex2 = tex2D(_MainTex, float2(i.uv.x - _OffsetParams.x, i.uv.y - _OffsetParams.z));
                float R = mainTex2.r;
                float4 mainTex3 = tex2D(_MainTex, float2(i.uv.x - _OffsetParams.y, i.uv.y - _OffsetParams.w));
                float B = mainTex3.b;

                float3 finalRGB = float3(R, G, B);

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}