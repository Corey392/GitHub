--
-- Name: fn_insertstudent(text, text, text, text, text, text, text, text, text, integer, text, text, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertstudent("userID" text, "email" text, "firstName" text, "lastName" text, "otherName" text, "addressLine1" text, "addressLine2" text, "town" text, "state" text, "postCode" integer, "phoneNumber" text, "studentID" text, "staff" boolean) RETURNS text
    LANGUAGE plpgsql
    AS $_$
    DECLARE pw TEXT;

    BEGIN
		SELECT INTO pw fn_InsertUser($1, 'S', $2, $3, $4);
		INSERT INTO "Student"("userID", "otherName", "addressLine1", "addressLine2", "town", "state", "postCode", "phoneNumber", "studentID", "staff")
			VALUES($1, $5, $6, $7, $8, $9, $10, $11, $12, $13);
		RETURN pw;
    END;
$_$;

--
-- Name: fn_insertuser(text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertuser("userID" text, role character, "email" text, "firstName" text, "lastName" text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
    DECLARE pw TEXT;

    BEGIN
        SELECT INTO pw fn_GeneratePassword();

        PERFORM fn_InsertUser($1, pw, $2, $3, $4, $5);
        RETURN pw;
    END;
$_$;
