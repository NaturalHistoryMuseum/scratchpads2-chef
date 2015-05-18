DROP FUNCTION IF EXISTS murmur_hash;
DROP FUNCTION IF EXISTS fnv1a_64;
DROP FUNCTION IF EXISTS fnv_64;
CREATE FUNCTION murmur_hash RETURNS INTEGER SONAME 'libmurmur_udf.so';
CREATE FUNCTION fnv1a_64 RETURNS INTEGER SONAME 'libfnv1a_udf.so';
CREATE FUNCTION fnv_64 RETURNS INTEGER SONAME 'libfnv_udf.so';