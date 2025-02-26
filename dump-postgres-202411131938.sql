PGDMP      &            
    |            postgres    16.4    16.4 6    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    5    postgres    DATABASE     |   CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE postgres;
                postgres    false            �           0    0    DATABASE postgres    COMMENT     N   COMMENT ON DATABASE postgres IS 'default administrative connection database';
                   postgres    false    4843                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
                pg_database_owner    false            �           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                   pg_database_owner    false    5            �            1259    16405    material    TABLE     �   CREATE TABLE public.material (
    material_id integer NOT NULL,
    names character varying(50),
    defect double precision
);
    DROP TABLE public.material;
       public         heap    postgres    false    5            �            1259    16404    material_material_id_seq    SEQUENCE     �   CREATE SEQUENCE public.material_material_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.material_material_id_seq;
       public          postgres    false    217    5            �           0    0    material_material_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.material_material_id_seq OWNED BY public.material.material_id;
          public          postgres    false    216            �            1259    16431    materialproduct    TABLE     q   CREATE TABLE public.materialproduct (
    mp_id integer NOT NULL,
    iproduct integer,
    imaterial integer
);
 #   DROP TABLE public.materialproduct;
       public         heap    postgres    false    5            �            1259    16430    materialproduct_mp_id_seq    SEQUENCE     �   CREATE SEQUENCE public.materialproduct_mp_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.materialproduct_mp_id_seq;
       public          postgres    false    223    5            �           0    0    materialproduct_mp_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.materialproduct_mp_id_seq OWNED BY public.materialproduct.mp_id;
          public          postgres    false    222            �            1259    16457    partnerproduct    TABLE     �   CREATE TABLE public.partnerproduct (
    pp_id integer NOT NULL,
    id_product integer,
    id_partner integer,
    quantity integer,
    date_of_sale date
);
 "   DROP TABLE public.partnerproduct;
       public         heap    postgres    false    5            �            1259    16456    partnerproduct_pp_id_seq    SEQUENCE     �   CREATE SEQUENCE public.partnerproduct_pp_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.partnerproduct_pp_id_seq;
       public          postgres    false    227    5            �           0    0    partnerproduct_pp_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.partnerproduct_pp_id_seq OWNED BY public.partnerproduct.pp_id;
          public          postgres    false    226            �            1259    16448    partners    TABLE     Y  CREATE TABLE public.partners (
    partners_id integer NOT NULL,
    type_partner character varying(50),
    company_name character varying(100),
    u_address character varying(150),
    inn character varying(50),
    director_name character varying(100),
    phone character varying(20),
    email character varying(75),
    rating integer
);
    DROP TABLE public.partners;
       public         heap    postgres    false    5            �            1259    16447    partners_partners_id_seq    SEQUENCE     �   CREATE SEQUENCE public.partners_partners_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.partners_partners_id_seq;
       public          postgres    false    225    5            �           0    0    partners_partners_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.partners_partners_id_seq OWNED BY public.partners.partners_id;
          public          postgres    false    224            �            1259    16419    product    TABLE     �   CREATE TABLE public.product (
    product_id integer NOT NULL,
    prodtype integer,
    description character varying(100),
    article integer,
    price double precision
);
    DROP TABLE public.product;
       public         heap    postgres    false    5            �            1259    16418    product_product_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.product_product_id_seq;
       public          postgres    false    5    221            �           0    0    product_product_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.product_product_id_seq OWNED BY public.product.product_id;
          public          postgres    false    220            �            1259    16412    producttype    TABLE     �   CREATE TABLE public.producttype (
    type_id integer NOT NULL,
    type_name character varying(50),
    coefficient double precision
);
    DROP TABLE public.producttype;
       public         heap    postgres    false    5            �            1259    16411    producttype_type_id_seq    SEQUENCE     �   CREATE SEQUENCE public.producttype_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.producttype_type_id_seq;
       public          postgres    false    219    5            �           0    0    producttype_type_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.producttype_type_id_seq OWNED BY public.producttype.type_id;
          public          postgres    false    218            4           2604    16408    material material_id    DEFAULT     |   ALTER TABLE ONLY public.material ALTER COLUMN material_id SET DEFAULT nextval('public.material_material_id_seq'::regclass);
 C   ALTER TABLE public.material ALTER COLUMN material_id DROP DEFAULT;
       public          postgres    false    217    216    217            7           2604    16434    materialproduct mp_id    DEFAULT     ~   ALTER TABLE ONLY public.materialproduct ALTER COLUMN mp_id SET DEFAULT nextval('public.materialproduct_mp_id_seq'::regclass);
 D   ALTER TABLE public.materialproduct ALTER COLUMN mp_id DROP DEFAULT;
       public          postgres    false    223    222    223            9           2604    16460    partnerproduct pp_id    DEFAULT     |   ALTER TABLE ONLY public.partnerproduct ALTER COLUMN pp_id SET DEFAULT nextval('public.partnerproduct_pp_id_seq'::regclass);
 C   ALTER TABLE public.partnerproduct ALTER COLUMN pp_id DROP DEFAULT;
       public          postgres    false    226    227    227            8           2604    16451    partners partners_id    DEFAULT     |   ALTER TABLE ONLY public.partners ALTER COLUMN partners_id SET DEFAULT nextval('public.partners_partners_id_seq'::regclass);
 C   ALTER TABLE public.partners ALTER COLUMN partners_id DROP DEFAULT;
       public          postgres    false    225    224    225            6           2604    16422    product product_id    DEFAULT     x   ALTER TABLE ONLY public.product ALTER COLUMN product_id SET DEFAULT nextval('public.product_product_id_seq'::regclass);
 A   ALTER TABLE public.product ALTER COLUMN product_id DROP DEFAULT;
       public          postgres    false    221    220    221            5           2604    16415    producttype type_id    DEFAULT     z   ALTER TABLE ONLY public.producttype ALTER COLUMN type_id SET DEFAULT nextval('public.producttype_type_id_seq'::regclass);
 B   ALTER TABLE public.producttype ALTER COLUMN type_id DROP DEFAULT;
       public          postgres    false    218    219    219            �          0    16405    material 
   TABLE DATA           >   COPY public.material (material_id, names, defect) FROM stdin;
    public          postgres    false    217   �>       �          0    16431    materialproduct 
   TABLE DATA           E   COPY public.materialproduct (mp_id, iproduct, imaterial) FROM stdin;
    public          postgres    false    223   ?       �          0    16457    partnerproduct 
   TABLE DATA           _   COPY public.partnerproduct (pp_id, id_product, id_partner, quantity, date_of_sale) FROM stdin;
    public          postgres    false    227   F?       �          0    16448    partners 
   TABLE DATA           �   COPY public.partners (partners_id, type_partner, company_name, u_address, inn, director_name, phone, email, rating) FROM stdin;
    public          postgres    false    225   @       �          0    16419    product 
   TABLE DATA           T   COPY public.product (product_id, prodtype, description, article, price) FROM stdin;
    public          postgres    false    221   �B       �          0    16412    producttype 
   TABLE DATA           F   COPY public.producttype (type_id, type_name, coefficient) FROM stdin;
    public          postgres    false    219   D       �           0    0    material_material_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.material_material_id_seq', 5, true);
          public          postgres    false    216            �           0    0    materialproduct_mp_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.materialproduct_mp_id_seq', 5, true);
          public          postgres    false    222            �           0    0    partnerproduct_pp_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.partnerproduct_pp_id_seq', 16, true);
          public          postgres    false    226            �           0    0    partners_partners_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.partners_partners_id_seq', 8, true);
          public          postgres    false    224            �           0    0    product_product_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.product_product_id_seq', 5, true);
          public          postgres    false    220            �           0    0    producttype_type_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.producttype_type_id_seq', 5, true);
          public          postgres    false    218            ;           2606    16410    material material_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.material
    ADD CONSTRAINT material_pkey PRIMARY KEY (material_id);
 @   ALTER TABLE ONLY public.material DROP CONSTRAINT material_pkey;
       public            postgres    false    217            A           2606    16436 $   materialproduct materialproduct_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.materialproduct
    ADD CONSTRAINT materialproduct_pkey PRIMARY KEY (mp_id);
 N   ALTER TABLE ONLY public.materialproduct DROP CONSTRAINT materialproduct_pkey;
       public            postgres    false    223            E           2606    16462 "   partnerproduct partnerproduct_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.partnerproduct
    ADD CONSTRAINT partnerproduct_pkey PRIMARY KEY (pp_id);
 L   ALTER TABLE ONLY public.partnerproduct DROP CONSTRAINT partnerproduct_pkey;
       public            postgres    false    227            C           2606    16455    partners partners_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.partners
    ADD CONSTRAINT partners_pkey PRIMARY KEY (partners_id);
 @   ALTER TABLE ONLY public.partners DROP CONSTRAINT partners_pkey;
       public            postgres    false    225            ?           2606    16424    product product_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (product_id);
 >   ALTER TABLE ONLY public.product DROP CONSTRAINT product_pkey;
       public            postgres    false    221            =           2606    16417    producttype producttype_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.producttype
    ADD CONSTRAINT producttype_pkey PRIMARY KEY (type_id);
 F   ALTER TABLE ONLY public.producttype DROP CONSTRAINT producttype_pkey;
       public            postgres    false    219            G           2606    16442 .   materialproduct materialproduct_imaterial_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.materialproduct
    ADD CONSTRAINT materialproduct_imaterial_fkey FOREIGN KEY (imaterial) REFERENCES public.material(material_id);
 X   ALTER TABLE ONLY public.materialproduct DROP CONSTRAINT materialproduct_imaterial_fkey;
       public          postgres    false    217    223    4667            H           2606    16437 -   materialproduct materialproduct_iproduct_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.materialproduct
    ADD CONSTRAINT materialproduct_iproduct_fkey FOREIGN KEY (iproduct) REFERENCES public.product(product_id);
 W   ALTER TABLE ONLY public.materialproduct DROP CONSTRAINT materialproduct_iproduct_fkey;
       public          postgres    false    223    221    4671            I           2606    16468 -   partnerproduct partnerproduct_id_partner_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.partnerproduct
    ADD CONSTRAINT partnerproduct_id_partner_fkey FOREIGN KEY (id_partner) REFERENCES public.partners(partners_id);
 W   ALTER TABLE ONLY public.partnerproduct DROP CONSTRAINT partnerproduct_id_partner_fkey;
       public          postgres    false    225    4675    227            J           2606    16463 -   partnerproduct partnerproduct_id_product_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.partnerproduct
    ADD CONSTRAINT partnerproduct_id_product_fkey FOREIGN KEY (id_product) REFERENCES public.product(product_id);
 W   ALTER TABLE ONLY public.partnerproduct DROP CONSTRAINT partnerproduct_id_product_fkey;
       public          postgres    false    221    4671    227            F           2606    16425    product product_prodtype_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_prodtype_fkey FOREIGN KEY (prodtype) REFERENCES public.producttype(type_id);
 G   ALTER TABLE ONLY public.product DROP CONSTRAINT product_prodtype_fkey;
       public          postgres    false    221    4669    219            �   U   x�3估��.칰�bӅ���v_ؠ`�i�g�e�G�P��)�1%�@%F\&x�� ���r��Qb
Tbl����� �a8      �   (   x��A 0İwfR���Ǳ�.��4��s��=�LN2      �   �   x�U��� C��.���K���v҄�q�K�:�Bg3oƦ�^2[�d���v�m���͇��.̓�Sf��)���0uH+��3��q����4�� #uU�0���g�.�<S\Q���y�k��Y/_lL�늖�l�~��2,��1�`H~d�����gH%0�K3��R�/۷;�      �   �  x��TKn�@]�N10i��g��٨�AR;p\�E1�|P���I.P(��:q�\�s�>R���˂����Ǳ������-ݐJ�M7�V*�3��-M�Tт��b3��	=R�>i,�Q�7t#8n\4�q*w���A�XBV�hiwJ���[�s�3N�ҁ1�Zk�0"_ItE�pZ"l�_��
�La�hBsw����4Mu�UG��a��;��v��
|/QH��Bl}8���P���H&ؚP����Qh�j�Tј���k���ɡ�u�%S�2T�<��c#�oQ�SͲ���fB-�TAf1��F4tM�bi�)R�C�`pw뼥m �Y�4\5��n$��>�AC!v�a���%E��<`g?t�{ݼ]�����"�y�l�0�1��a ;��&SAբ�@��`n�����R�Kn>�D�p���\����JU�\Q�xM%��:g��ګ��&g�m��T���A�*fꅜM��>��*��ܝ� M���~G%Kav*��n�n�Ol��S�R���?�a�-X¬���u �R1Ɵ�)���op� ��Ѿ���Q�Wtx�h��{�R����j7R1赌��(���v"�%]n�/�-���*��D�I��+��/��B����A	�knJ#��D���������|Q�uz�կ���p�4��K�3e�4��4��$�n��MX�Y      �   #  x�u�MN�0���)|���w�0IA��H,ذo�j�Ob�0��NT�D9r�=�/3�L3z�!wt��W4a�$hG)�(�6�D��Z@�4b�HA	�	�o�S��g�0��;뵷�{��
��ϒV��9��V�;��{|~�Z1Fp��"Z-ho}��9�[�5��^�8Ҿ:Wg������(]Ѷ0j{Z�N�ܟ�����IB�57���r7G��Q�&A��� %:0�\g<�>���s��`	?U,XQ��v^��9;�YE=4Zڣ��\�m��F3kl���o���?(�      �   u   x�e���0�wUP�I�v7|�H �a	��ia�#V��:������|Q|��b�^�2M>�o���aG#8Q$[�/#I��.%�I%*o��_�Ï�����,�`�zo�Q�     