Shader "MineselfShader/VFX/11-ScreenUV/ViewUV"
{
    Properties
    {
        [NoScaleOffset]_MainTex("MainTexture", 2D) = "white"{}
        _Scale("Scale", vector) = (1,1,0,0)
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
            float2 _Scale;
                
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
                float2 screenUV : TEXCOORD0;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                //����"��Ļ"�ռ�uv��Ҳ���ǹ۲�ռ�uv
                float3 vPos = UnityObjectToViewPos(v.vertex);
                //������vPos.z��pivotZ������ϵ��
                //����һ��һ�������б�ӽ���������
                //���ֻ��pivotZ(ɾ��vPos.z)����ʱ���Գ�����ԶС�����Ч��
                o.screenUV = vPos.xy / vPos.z;
                //***��Ӧ�����***���ᵼ��uv���·�ת
                //o.screenUV.y *= _ProjectionParams.x;
                float pivotZ = UnityObjectToViewPos(float3(0, 0, 0)).z;
                o.screenUV = o.screenUV * pivotZ * _Scale;

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.screenUV);

                return mainTex;
            }
            ENDCG
        }
    }
    Fallback Off
}