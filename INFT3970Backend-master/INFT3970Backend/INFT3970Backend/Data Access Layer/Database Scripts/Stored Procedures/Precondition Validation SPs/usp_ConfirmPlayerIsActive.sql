-- =============================================
-- Author:		Jonathan Williams
-- Create date: 15/09/18
-- Description:	Confirms the PlayerID exists and is active.
-- =============================================
CREATE PROCEDURE usp_ConfirmPlayerIsActive
	@id INT,
	@result INT OUTPUT,
	@errorMSG VARCHAR(255) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--Declare the error codes
	DECLARE @DATABASE_CONNECT_ERROR INT = 0;
    DECLARE @INSERT_ERROR INT = 2;
    DECLARE @BUILD_MODEL_ERROR INT = 3;
    DECLARE @ITEM_ALREADY_EXISTS INT = 4;
    DECLARE @DATA_INVALID INT = 5;
    DECLARE @ITEM_DOES_NOT_EXIST INT = 6;
    DECLARE @CANNOT_PERFORM_ACTION INT = 7;
    DECLARE @GAME_DOES_NOT_EXIST INT = 8;
    DECLARE @GAME_STATE_INVALID INT = 9;
    DECLARE @PLAYER_DOES_NOT_EXIST INT = 10;
    DECLARE @PLAYER_INVALID INT = 11;
    DECLARE @MODELINVALID_PLAYER INT = 12;
    DECLARE @MODELINVALID_GAME INT = 13;
    DECLARE @MODELINVALID_PHOTO INT = 14;
    DECLARE @MODELINVALID_VOTE INT = 15;

	--Confirm the playerID passed in exists
	EXEC [dbo].[usp_ConfirmPlayerExists] @id = @id, @result = @result OUTPUT, @errorMSG = @errorMSG OUTPUT

	--If the player exists, check if the player is active
	IF(@result = 1)
	BEGIN
		IF NOT EXISTS (SELECT * FROM vw_Active_Players WHERE PlayerID = @id)
		BEGIN
			SELECT @result = @PLAYER_INVALID;
			SET @errorMSG = 'The PlayerID is not active.';
		END
		ELSE
		BEGIN
			SELECT @result = 1;
			SET @errorMSG = '';
		END
	END
END
GO